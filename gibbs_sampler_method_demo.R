setwd("~/CodeRMain/shinyApps/best_pflocker_team")
pf_lockers <- read.csv('LoveliveSIF_CNServer_pfLocker_card_list.csv')
require(lattice)
song_len <- 4 * 60 * 2
note_num <- 350

# Make a matrix, rows are time seq of each card
example <- c(58, 59, 73, 92, 122, 133, 134, 143, 202, 212, 220, 246, 264, 272)
example_cards <- pf_lockers[pf_lockers$CardID %in% example, ]
gen_time_seq <- function(card_id) {
    ## Get the card info by card ID
    card <- example_cards[example_cards$CardID == card_id, ]
    ## If card appeal checks by notes, convert it into seconds
    if (card$Type == 'N') card$Jump <- floor(card$Jump * (song_len / note_num))
    time_seq <- numeric(song_len)
    check <- which({1:song_len / 2} %% 
                       card$Jump == 0)
    for (i in check) 
        time_seq[i:min(i + card$Duration * 2, song_len)] <- card$Rate / 100
    time_seq
}
time_seq_mat <- sapply(example, gen_time_seq)

# Initialize sampling
## Samples are represented by logical vectors
gibbs_samp <- sample(c(rep(T, 9), rep(F, length(example) - 9)))
gen_effect_seq <- function(sample_vect) {
    apply(time_seq_mat[, sample_vect], 1, function(row) {
        1 - prod(1 - row)
    })
}

# xyplot(gen_effect_seq(gibbs_samp) ~ 1:song_len, type = 's',
#        ylim = c(0, 1))

## Execute gibbs sampler
record_effect <- 0
max_effect <- 0
max_samp <- logical(length(example))
rep_time <- 1
for (iter in 1:200) {
    # Firstly, discard 1 card, pr depends on conttribution to the effect seq
    cur_effect <- sum(gen_effect_seq(gibbs_samp))
    
        ## but if max effect has appeared over 50 times use the max effect
        if (cur_effect > max_effect) {
            max_effect <- cur_effect
            max_samp <- gibbs_samp
            rep_time <- 1
        } else if (cur_effect == max_effect) rep_time <- rep_time + 1
        if (rep_time > 50) break
    
    record_effect[iter] <- cur_effect
    loss_of_effect <- sapply(which(gibbs_samp), function(exclude) {
        cur_effect - sum(
            gen_effect_seq(ifelse(1:length(example) != exclude, gibbs_samp, F))
        )
    })
    discard <- sample(which(gibbs_samp), 1, 
                      prob = {max(loss_of_effect) / loss_of_effect - 1} ** 2)
    gibbs_samp[discard] <- F
    # Then, select 1 card
    cur_effect <- sum(gen_effect_seq(gibbs_samp))
    gain_of_effect <- sapply(which(!gibbs_samp), function(append) {
        sum(
            gen_effect_seq(ifelse(1:length(example) != append, gibbs_samp, T))
        ) - cur_effect
    })
    insert <- sample(which(!gibbs_samp), 1,
                     prob = {gain_of_effect / min(gain_of_effect) - 1} ** 2)
    gibbs_samp[insert] <- T
}
record_effect <- c(record_effect, sum(gen_effect_seq(gibbs_samp)))

# levelplot(as.matrix(gen_effect_seq(max_samp)), aspect = 0.1)
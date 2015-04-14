run_gibbs_sampler <- function(selected, card_list, song_len, note_num) {
    
    gen_effect_seq <- function(sample_vect) {
        apply(time_seq_mat[, sample_vect], 1, function(row) {
            1 - prod(1 - row)
        })
    }
    
    gen_time_seq <- function(card_id, selected_cards) {
        ## Get the card info by card ID
        card <- selected_cards[selected_cards$CardID == card_id, ]

        ## If card appeal checks by notes, convert it into seconds
        if (card$Type == 'N') card$Jump <- floor(card$Jump * (song_len / note_num))
        time_seq <- numeric(song_len)
        
        check <- which({1:song_len / 2} %% 
                           card$Jump == 0)
        for (i in check) 
            time_seq[i:min(i + card$Duration * 2, song_len)] <- card$Rate / 100
        time_seq
    }
    
    # get card subset and generated time sequence effect matrix
    selected_cards <- card_list[card_list$CardID %in% selected, ]
    time_seq_mat <- sapply(selected, gen_time_seq, selected_cards)
    
    # initialize the sampler
    gibbs_samp <- sample(c(rep(T, 9), rep(F, length(selected) - 9)))
    record_effect <- 0
    max_effect <- 0
    max_samp <- logical(length(selected))
    rep_time <- 1
    
    for (iter in 1:100) {
        incProgress(0.9 / 100)
        
        # Firstly, discard 1 card, pr depends on conttribution to the effect seq
        cur_effect <- sum(gen_effect_seq(gibbs_samp))
        
        ## but if max effect has appeared over 50 times use the max effect
        if (cur_effect > max_effect) {
            max_effect <- cur_effect
            max_samp <- gibbs_samp
            rep_time <- 1
        } else if (cur_effect == max_effect) rep_time <- rep_time + 1
        if (rep_time > 20) break
        
        record_effect[iter] <- cur_effect
        loss_of_effect <- sapply(which(gibbs_samp), function(exclude) {
            cur_effect - sum(
                gen_effect_seq(ifelse(1:length(selected) != exclude, gibbs_samp, F))
            )
        })
        discard <- sample(which(gibbs_samp), 1, 
                          prob = {max(loss_of_effect) / loss_of_effect - 1} ** 2)
        gibbs_samp[discard] <- F
        # Then, select 1 card
        cur_effect <- sum(gen_effect_seq(gibbs_samp))
        gain_of_effect <- sapply(which(!gibbs_samp), function(append) {
            sum(
                gen_effect_seq(ifelse(1:length(selected) != append, gibbs_samp, T))
            ) - cur_effect
        })
        insert <- sample(which(!gibbs_samp), 1,
                         prob = {gain_of_effect / min(gain_of_effect) - 1} ** 2)
        gibbs_samp[insert] <- T
    }
    record_effect <- c(record_effect, sum(gen_effect_seq(gibbs_samp)))
    
    list(team = selected[gibbs_samp],
         effect = gen_effect_seq(gibbs_samp),
         record = record_effect)
}
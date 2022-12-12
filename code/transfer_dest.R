# count total destination
xfr_dest_count <- nrow(`transfer-destinations`)

# count mandatory destination
xfr_dest_mandatory_count <- nrow(`transfer-destinations`[`transfer-destinations`$transfer_destination_mandatory,])

# split on-off destination
xfr_dest_off <- sum(str_count(`transfer-destinations`$transfer_destination_name, "Off-"))
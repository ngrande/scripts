#!/bin/bash

# send email
echo "$SMARTD_MESSAGE" | mail -s "$SMARTD_FAILTYPE" "$SMARTD_ADDRESS"

# notify user
wall "$SMARTD_MESSAGE"

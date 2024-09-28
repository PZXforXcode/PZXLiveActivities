export TEAM_ID=KCNSS22SRZ
export TOKEN_KEY_FILE_NAME=AuthKey_5S685SDQG3.p8
export AUTH_KEY_ID=5S685SDQG3
export DEVICE_TOKEN=80859e1a48083a83db6fc4e381aec0efbeeec0025823518d380a66497189196475f1a2fce6834db57e40bfa45309bb3104f1622e1091e6ec728e034a5ee7507f63a177e1787dfe4a4c47707795d4991c
export APNS_HOST_NAME=api.sandbox.push.apple.com

export JWT_ISSUE_TIME=$(date +%s)
export JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
export JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

curl -v \
--header "apns-topic:com.pingalax.EICharge.push-type.liveactivity" \
--header "apns-push-type:liveactivity" \
--header "apns-priority: 10" \
--header "authorization: bearer $AUTHENTICATION_TOKEN" \
--data \
'{"Simulator Target Bundle": "com.pingalax.EICharge",
"aps": {
  "timestamp":'"$JWT_ISSUE_TIME"',
   "dismissal-date":0,
   "event": "update",
   "sound":"default",
   "content-state": {
       "name": "充电中2",
       "status": 2
   }
}}' \
--http2 \
https://${APNS_HOST_NAME}/3/device/$DEVICE_TOKEN

# -------------------

 export TEAM_ID=KCNSS22SRZ
 export TOKEN_KEY_FILE_NAME=AuthKey_5S685SDQG3.p8
 export AUTH_KEY_ID=5S685SDQG3
 export DEVICE_TOKEN=801e5d076bd6f75b1694e6d91108670d405bd84539333b4d048a152b2796d7f959948ce0c23f0a2933f87259b9e3e54bea2b2eb2ca1986ef5b8f2e568cbe10dbd4badd78f3062565ec74f6f6ccd0f596
 export APNS_HOST_NAME=api.sandbox.push.apple.com

 export JWT_ISSUE_TIME=$(date +%s)
 export JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
 export JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
 export JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
 export JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
 export AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

 curl -v \
 --header "apns-topic:com.pingalax.EICharge.push-type.liveactivity" \
 --header "apns-push-type:liveactivity" \
 --header "apns-priority: 10" \
 --header "authorization: bearer $AUTHENTICATION_TOKEN" \
 --data \
 '{"Simulator Target Bundle": "com.pingalax.EICharge",
 "aps": {
    "timestamp":'"$JWT_ISSUE_TIME"',
    "event": "update",
    "sound":"default",
    "content-state": {
       "name": "充电完成",
       "price":"RM 12.10",
       "no":"NO7768897654681HGD",
       "status": 1
    },
 }}' \
 --http2 \
 https://${APNS_HOST_NAME}/3/device/$DEVICE_TOKEN

export TEAM_ID=KCNSS22SRZ
export TOKEN_KEY_FILE_NAME=AuthKey_5S685SDQG3.p8
export AUTH_KEY_ID=5S685SDQG3
export DEVICE_TOKEN=80457976e3023c02fcff5b1ac860cbd300eb10a127bcfd66b79d1125d4aa2e4251b37818c115ac000a639372012bb737974de4a4b6b48632c6ca594d41809ad1132c991b0df982c775194ab9d646c5ae
export APNS_HOST_NAME=api.sandbox.push.apple.com

export JWT_ISSUE_TIME=$(date +%s)
export JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
export JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

curl  \
--header "apns-topic:com.pingalax.EICharge.push-type.liveactivity" \
--header "apns-push-type:liveactivity" \
--header "apns-priority: 10" \
--header "apns-expiration: 0" \
--header "authorization: bearer $AUTHENTICATION_TOKEN" \
--data \
'{"Simulator Target Bundle": "com.pingalax.EICharge",
"aps": {
  "timestamp":'"$JWT_ISSUE_TIME"',
   "dismissal-date":0,
   "event": "update",
   "sound":"default",
   "content-state": {
       "name": "充电中"
       "price": RM 12.0"
       "status": 2
   }
}}' \
--http2 \
https://${APNS_HOST_NAME}/3/device/$DEVICE_TOKEN

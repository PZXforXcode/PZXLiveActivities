export TEAM_ID=KCNSS22SRZ
export TOKEN_KEY_FILE_NAME=AuthKey_5S685SDQG3.p8
export AUTH_KEY_ID=5S685SDQG3
export DEVICE_TOKEN=80cebc2a3259fc5500b2283dbc68776f41858f58480cb22a44db5c4f0db12c1abcea3b2cfaa4a34c832bf5705b509237695af62a186bcb9802260b708459aa6b0a78e9d8d4e81e17a5289eaa6f884787
export APNS_HOST_NAME=api.sandbox.push.apple.com:2197

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

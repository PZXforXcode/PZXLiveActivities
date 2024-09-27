export TEAM_ID=KCNSS22SRZ
export TOKEN_KEY_FILE_NAME=AuthKey_5S685SDQG3.p8
export AUTH_KEY_ID=5S685SDQG3
export DEVICE_TOKEN=80936829badcbcdc88172c9f5a3d8d9c78d9d8dd3d21cc81919bda3bdc3fee3e3b6d397b59babb52e10a23ff0203fa441f278fe7120b2645320cb1e2f8bf49fa41b0963018ee306e5369a5c7fd2c9d2a
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
 export DEVICE_TOKEN=806e1488e10e3c1a2add64d57ef6d8844f55bbcb748256b34bc233771e87c8fc5e4722f716d60005f96322d59dfe96781516cbbb9889021af35d4e3432d6141d708aa445f8f102f664f70cd21026ec21
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
       "status": 4
    },
 }}' \
 --http2 \
 https://${APNS_HOST_NAME}/3/device/$DEVICE_TOKEN

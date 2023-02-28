if [[ "${TOKEN}" == "" ]] || [[ "${DOMAIN}" == "" ]] || [[ "${ZONE_ID}" == "" ]]; then
	echo Required variable is not set
	exit 1
fi

EXTERNAL_IP=$(curl -s https://ipipip.kr/raw)

echo Your IP is: $EXTERNAL_IP

cloudflare_record_info=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$DOMAIN" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json")

cloudflare_dns_record_id=$(echo ${cloudflare_record_info} | grep -o '"id":"[^"]*' | cut -d'"' -f4)
is_proxied=$(echo ${cloudflare_record_info} | grep -o '"proxied":[^,]*' | grep -o '[^:]*$')
dns_record_ip=$(echo ${cloudflare_record_info} | grep -o '"content":"[^"]*' | cut -d'"' -f 4)

if [[ "${cloudflare_dns_record_id}" == "" ]]; then
	echo Error on fetching DNS Record ID
	echo $cloudflare_record_info
	exit 1
fi

if [[ "${dns_record_ip}" == "${EXTERNAL_IP}" ]]; then
	echo "DNS IP(${dns_record_ip}) is identical with External IP(${EXTERNAL_IP})"
	exit 0
fi

update_dns_record=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$cloudflare_dns_record_id" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$DOMAIN\",\"content\":\"$EXTERNAL_IP\",\"ttl\":120,\"proxied\":$is_proxied}")

if [[ "${update_dns_record}" == *"\"success\":false"* ]]; then
  echo ${update_dns_record}
  echo "Error! Update Failed"
  exit 0
fi

echo "==> Success!"
echo "==> $DOMAIN DNS Record Updated To: $EXTERNAL_IP, ttl: 120, proxied: $is_proxied"

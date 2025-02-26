if [[ -z "$1" ]]; then
   echo "Usage: ./generate-certificate.sh <url>"
   exit 1
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=$1/O=$1"
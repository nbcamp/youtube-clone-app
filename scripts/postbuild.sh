source $SRCROOT/.env
ENV_FILE=$SRCROOT/YoutubeCloneApp/Utilities/Env.swift

while IFS="=" read -r key value; do
  if grep -q "$value" "$ENV_FILE"; then
    sed -i '' "s/$value/$key/g" "$ENV_FILE"
  fi
done < <(env | grep "^ENV_VAR_")

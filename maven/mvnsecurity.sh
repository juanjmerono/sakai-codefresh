#!/bin/bash
if [ ! -z $MASTER_PASSWORD ] 
then
	echo "Encrypting maven settings..."
	mvn -emp $MASTER_PASSWORD | sed -e 's/[\/&]/\\&/g' > $HOME/mvnmp.txt
	MASTER_PASSWORD_ENC=$(cat $HOME/mvnmp.txt)
	sed -i -e 's/##MASTER_PASS##/'$MASTER_PASSWORD_ENC'/g' ./maven/settings-security.xml
	mkdir -p /root/.m2/
	cp ./maven/settings-security.xml /root/.m2/settings-security.xml
	mvn -ep $ORACLE_PASS | sed -e 's/[\/&]/\\&/g' > $HOME/mvnsrv.txt
	ORACLE_PASS_ENC=$(cat $HOME/mvnsrv.txt)
	sed -i -e 's/##ORA_USER##/'$ORACLE_USER'/g' ./maven/settings.xml
	sed -i -e 's/##ORA_PASS##/'$ORACLE_PASS_ENC'/g' ./maven/settings.xml
else
	echo "Missing master password..."
fi
if [ "$DEBUG_ENC" == "true" ]
then
	echo "Debugging maven encryption..."
	grep -e 'user\|pass\|master' ./maven/*.xml
else
	echo "Not debugging..."
fi
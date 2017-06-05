#!/usr/bin/env bash
#################################################################################
#
#                     ##########  ##########   ##########   ########## 
#                    ##########  ##########   ##########   ##########
#                   ###         ###              ###      ###
#                  ###         #########        ###      ###  
#                 ###           ########       ###      ###
#                ###                ###       ###      ###
#               ##########  ##########   ###########  ###########
#               #########  ##########   ###########   ########## 
#
#          This is the CSIC global parameters file for every scripts
#
#
#                        (C) CSI  (Siemens AG, 2006)
#################################################################################

. /var/opt/csic/config/csic.env

# Adjust the following parameters according to your configuration --------------


CSIC_JAR=${CSIC_ROOT}/jar
CSIC_LIB=${CSIC_ROOT}/lib
export CSIC_JAR CSIC_LIB
  

JACORB_HOME=${CSIC_VAR}/jacorb 
export JACORB_HOME


JAVA="${JAVA_ROOT}/bin/java"
#PROPS="-Xmx${JVM_SIZE}m -DBASE_PATH=${CSIC_VAR} -DCSIC_LOG=${CSIC_LOG} -Djacorb.home=${JACORB_HOME} -Dorg.omg.CORBA.ORBClass=org.jacorb.orb.ORB -Dorg.omg.CORBA.ORBSingletonClass=org.jacorb.orb.ORBSingleton "
PROPS="-XX:PermSize=256m -XX:MaxPermSize=1024m -Xmx4096m -Xms1024m -DBASE_PATH=${CSIC_VAR} -DCSIC_LOG=${CSIC_LOG} -Djacorb.home=${JACORB_HOME} -Dorg.omg.CORBA.ORBClass=org.jacorb.orb.ORB -Dorg.omg.CORBA.ORBSingletonClass=org.jacorb.orb.ORBSingleton "
export JAVA PROPS


NETACT_HOME=${CSIC_VAR}/netact
export NETACT_HOME

CSIC_NAME=`grep LONG_NAME ${CSIC_ROOT}/scripts/branding.properties | cut -d= -f2 | sed 's/^ *//g'`
if [[ -z ${CSIC_NAME} ]]
then
	CSIC_NAME="siriOSS PSA Lite"
fi


# Build CSIC variable -----------------------------------------------------------

  CSIC=""
  FL=0

  for J in ${CSIC_JAR}/*.jar
  do
      if [ "${FL}" == "1" ]
      then
         CSIC=${CSIC}':'
      fi
         FL=1
      CSIC=${CSIC}${J}
  done

  export CSIC

# Build CLSPATH variable -------------------------------------------------------

  CLSPATH=.:${CSIC}

  export CLSPATH

# Build LD_LIBRARY_PATH variable -----------------------------------------------

  LIBS=${JAVA_ROOT}/jre/lib/sparc
  LIBS=${LIBS}:${CSIC_LIB}

  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${LIBS}
  export LD_LIBRARY_PATH
  
  
function outrotate {
	# we need the Logical name as the first argument
	if [[ -z ${1} ]]
	then
		return 1
	fi
	
	OUT=${CSIC_OUT}/${1}.out
	OUT_OLD=${CSIC_OUT}/old/${1}.out
	ERR=${CSIC_OUT}/${1}.err
	ERR_OLD=${CSIC_OUT}/old/${1}.err
	
	for ((i = ${OLD_OUT_NUMBER}; i >= 2; i--))
	do
		/bin/mv -f ${OUT_OLD}.$((${i}-1)) ${OUT_OLD}.${i} 1>/dev/null 2>&1
		/bin/mv -f ${ERR_OLD}.$((${i}-1)) ${ERR_OLD}.${i} 1>/dev/null 2>&1
	done
	
	/bin/cp -f ${OUT} ${OUT_OLD}.1 1>/dev/null 2>&1
	/bin/cp -f ${ERR} ${ERR_OLD}.1 1>/dev/null 2>&1
}

# eof: globals.sh --------------------------------------------------------------


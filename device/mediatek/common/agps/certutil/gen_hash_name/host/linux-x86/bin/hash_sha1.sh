#!/bin/sh

# Use the prebuilt version
my_certutil=./bin/certutil

if [ -n "${ANDROID_HOST_OUT}" ]; then
   if IsUtilBuilt=`${ANDROID_HOST_OUT}/bin/certutil version`
   then
     # Use the new build version
     my_certutil=${ANDROID_HOST_OUT}/bin/certutil
   fi
fi

OUT_DIR=./0_pem_sha1

if [ ! -d "./CERT" ]; then
   echo "Please put root certs in ./CERT/"
   exit
else
   cert=`ls -1 ./CERT/`
   if [ -z "$cert" ]; then
      echo ./CERT/ is empty
      echo "Please put root certs in ./CERT/"
      exit
   fi
fi

if [ ! -d "${OUT_DIR}" ]; then
   mkdir ${OUT_DIR}
fi

for cert in ./CERT/* ;
  do
   SUFFIX=0
   echo =============================
   echo "${cert}"
   echo =============================
   echo --- Method 1 ---
   echo ${my_certutil} x509 -subject_hash -noout -in "${cert}"
   if hash_name=`${my_certutil} x509 -subject_hash -noout -in "${cert}"`
   then
      echo hash_name=$hash_name
      hash_name=${OUT_DIR}/${hash_name}
      while [ -f "${hash_name}.${SUFFIX}" ]; do
         let "SUFFIX += 1";
         echo SUFFIX=${SUFFIX}
      done
      ${my_certutil} x509 -in "${cert}" -out ${hash_name}.${SUFFIX}
      ${my_certutil} x509 -in "${cert}" -noout -text -fingerprint >> ${hash_name}.${SUFFIX}
   else
      echo --- Method 2 instead ---
      echo ${my_certutil} x509 -subject_hash -noout -in "${cert}" -inform DER
      if hash_name=`${my_certutil} x509 -subject_hash -noout -in "${cert}" -inform DER`
      then
        echo hash_name=$hash_name
        hash_name=${OUT_DIR}/${hash_name}
        while [ -f "${hash_name}.${SUFFIX}" ]; do
           let "SUFFIX += 1";
        done
        ${my_certutil} x509 -in "${cert}" -inform DER -out ${hash_name}.${SUFFIX}
        ${my_certutil} x509 -in "${cert}" -inform DER -noout -text -fingerprint >> ${hash_name}.${SUFFIX}
      else
        echo !!! Method 3 instead !!!
        echo ${my_certutil} x509 -subject_hash -noout -in "${cert}" -inform PEM
        if hash_name=`${my_certutil} x509 -subject_hash -noout -in "${cert}" -inform PEM`
        then
          echo hash_name=$hash_name
          hash_name=${OUT_DIR}/${hash_name}
          while [ -f "${hash_name}.${SUFFIX}" ]; do
             let "SUFFIX += 1";
          done
          ${my_certutil} x509 -in "${cert}" -inform PEM -out ${hash_name}.${SUFFIX}
          ${my_certutil} x509 -in "${cert}" -inform PEM -noout -text -fingerprint >> ${hash_name}.${SUFFIX}
        fi
      fi
   fi
done

DES_FOLDER='/home/orange/Work/Coding/CodeBackup/';
NEW_VERSION=HEAD;
OLD_VERSION=HEAD~1;
new_filename=${DES_FOLDER}NEW.tar
old_filename=${DES_FOLDER}OLD.tar
new_diff_filelist=${DES_FOLDER}diff_new.txt
old_diff_filelist=${DES_FOLDER}diff_old.txt
new_filefolder=NEW
old_filefolder=OLD
timestamp=$(date "+%Y%m%d-%H%M%S")
branchname=$(git branch | grep '*' | cut -d ' ' -f 2 | tr '/' '_')
archive_filename=${DES_FOLDER}diff_${timestamp}_${branchname}.tar
echo "${archive_filename}"

function clean_tmp_file {
	rm -f ${new_diff_filelist}
	rm -f ${old_diff_filelist}
}

function gen_archive_file {
	git diff --name-status ${OLD_VERSION} ${NEW_VERSION} | sed '/^D/d' | sed 's#[MAD]\s##g' | sed 's#^#"#g' | sed 's#$#"#g' > ${new_diff_filelist};
	# sed -i '/^D/d' 			${new_diff_filelist};
	# sed -i 's#[MAD]\s##g' 	${new_diff_filelist};
	# sed -i 's#^#"#g' 		${new_diff_filelist};
	# sed -i 's#$#"#g' 		${new_diff_filelist};
	cat ${new_diff_filelist} | tr "\n" " " | xargs git archive --format=tar -o ${new_filename} ${NEW_VERSION}
	# ret=$?
	# echo $ret
	# if [ ${ret} == 0 ]; then
	# 	mv ${new_filename} ${DES_FOLDER};
	# else
	# 	echo "there is no archive generated. ";
	# fi

	git diff --name-status ${NEW_VERSION} ${OLD_VERSION} | sed '/^D/d' | sed 's#[MAD]\s##g' | sed 's#^#"#g' | sed 's#$#"#g' > ${old_diff_filelist};
	# sed -i '/^D/d'          ${old_diff_filelist};
	# sed -i 's#[MAD]\s##g'   ${old_diff_filelist};
	# sed -i 's#^#"#g'        ${old_diff_filelist};
	# sed -i 's#$#"#g'        ${old_diff_filelist};
	cat ${old_diff_filelist} | tr "\n" " " | xargs git archive --format=tar -o ${old_filename} ${OLD_VERSION}
	# ret=$?
	# if [ ${ret} == 0 ]; then
	# 	mv ${old_filename} ${DES_FOLDER};
	# else
	# 	echo "there is no archive generated. ";
	# fi
}


cd ${DES_FOLDER}
if [[  -f ${old_filename} && -f ${new_filename} ]]; then
	rm -rf ${new_filefolder}
	rm -rf ${old_filefolder}
	mkdir ${new_filefolder}
	mkdir ${old_filefolder}
	tar -xvf ${new_filename} -C ${new_filefolder}
	tar -xvf ${old_filename} -C ${old_filefolder}
else
	echo "archive files are missing, please check. "
fi
tar -cvf ${archive_filename} ${new_filefolder} ${old_filefolder}
# rm ${new_filename}
# rm ${old_filename}

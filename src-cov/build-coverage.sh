#/bin/bash
lcov --capture --initial --directory ./libarchive --output-file baseline.info
for f in ../fuzzer/campaign/default/queue/*
do
	echo $f
	./fuzzer/fuzzer $f
done
lcov --no-checksum --directory ./ --capture --output-file queue_coverage.info
lcov --add-tracefile queue_coverage.info --add-tracefile baseline.info --output-file coverage.info
genhtml --highlight --legend -output-directory ./html-coverage/ ./coverage.info

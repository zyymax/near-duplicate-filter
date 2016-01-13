#!/bin/bash
#该脚本对文本进行必要的处理(去噪,分词,生成特征字典,提取指纹)，再进行自去重
#author:  max.zhang
#date:    2013-12-25
#usage:   sh filter_duplicate.sh data/22-24_short.content

#echo "Filtering duplicate in $1"
dir_path=`echo $1 | awk '{split($0, arr, "/");print arr[1];}'`
prefix=`echo $1 | awk '{split($0, arr, "/");print arr[2];}' | awk -F '.' '{print $1}'`
full_prefix=$dir_path/$prefix

#过滤字符，提取有效文本
#./webcontent_filter.sh $1 "$full_prefix.ori"
cp $1 "$full_prefix.ori"
cat "$full_prefix.ori" | awk '{if(length($0)>60){print NR"\t"$0}}' > "$full_prefix.rowori"
#rm -f "$full_prefix.ori"

#分词
python/tokens.py '-s'  "$full_prefix.rowori" "$full_prefix.token" 'c' 'data/stopwords.txt'
rm -f "$full_prefix.rowori"

#生成特征词典
python/DictBuilder.py "$full_prefix.token" "$full_prefix.dict"

#用hadoop streaming生成Simhash指纹
cp "$full_prefix.dict" 'word.dict'
cat "$full_prefix.token" | python/SimhashMapper.py > "$full_prefix.rowfprint"

#由.token和.rowfprint生成.lenfprint
sort -k1 -n "$full_prefix.token" > tmp_1
sort -k1 -n "$full_prefix.rowfprint" > tmp_2
paste tmp_1 tmp_2 |
awk -F '\t' '{print $1"\t"length($2)"\t"$4}' > $full_prefix.lenfprint
rm -f tmp_1
rm -f tmp_2
#自去重
python python/FilterSalientBySimhashNoScore.py $full_prefix.lenfprint \
     $full_prefix.lenfprint "$full_prefix"_uniq.lenfprint
#去重后文档集合
python/get_row_sample.py $1 "$full_prefix"_uniq.lenfprint > "$full_prefix"_uniq.content

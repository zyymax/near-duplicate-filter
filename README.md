# Near-Duplicate-Filter
  by max.zhang@2013-12-25

Brief:  此工具根据Simhash指纹过滤文档集合中近似重复的文档

## [Dependence]
   pip install Jieba

## [FILE]
    filter_duplicate.sh:	文本去重脚本，对长/短文本数据进行去噪、指纹提取并采用hamming距离除去重复文本
    webcontent_filter.sh:	文本预处理脚本，除去不可打印的字符、数字、字母，合并多个空白符
    python:	python脚本目录
      --tokens.py		jieba分词脚本
      --DictBuilder.py	特征词典构建脚本
      --SimhashMapper.py	Simhash指纹提取的streaming脚本
      --Utils.py		工具模块，包含hamming距离函数
      --FilterSalientBySimhashNoScore.py	根据Simhash指纹进行去重
      --get_row_sample.py	根据原始文本文件和去重后的行号文件生成去重后的样本

## [TO DO]
1.  生成文档集合文件, 每个文档占一行

        cat *.content > 22.content
2.  [自去重]启动去重脚本，生成去重后的_uniq.lenfprint指纹文件和去重后的文档集合_uniq.content文件

        ./sample_filter.sh data/22.content
3.  [与其他文档集合去重]根据其他文档集的.lenfprint文件和生成的_uniq.lenfprint文件生成新文档集的_uniq_new.lenfprint文件

        python/FilterSalientBySimhashNoScore.py data/22_uniq.lenfprint data/other_docs.lenfprint  data/22_uniq_new.lenfprint
4.  获取去重后剩余的文档集合

        python/get_row_sample.py data/22.content data/22_uniq_new.lenfprint > 22_uniq_new.content

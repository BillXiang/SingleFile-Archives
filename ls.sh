#!/usr/bin/bash
echo "<!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <script>
        var _hmt = _hmt || [];
        (function() {
          var hm = document.createElement('"script"');
          hm.src = '"https://hm.baidu.com/hm.js?ec59a7c509d311b9e44b32db0e8bc394"';
          var s = document.getElementsByTagName('"script"')[0];
          s.parentNode.insertBefore(hm, s);
        })();
      </script>
    </head>
    <body>
      <table id="myTable">
        <thead><tr><th>Index</th></tr></thead>
        <tbody>" > index.html

read_dir(){
    for file in $1/*;
    do
        #echo $file"####"
        if [ -d "$file" ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                #echo "DIR"
                read_dir "$file"
            fi
        else
            html=$(echo $file|grep "html$"|wc -l)
            if [[ "$html" -ne 0 ]];then
                ori_url=`head -n 3 "$file"|tail -n 1`
                ori_url=${ori_url:6}

                name=${file/\.\//}
                name=${name/书签工具栏/}
                name=${name/(*).html/}
                echo $name

                echo $file | awk -F'[/()]' '{print $(NF-1), $(NF-2)}' | while read a b c
                do
                    echo "<tr><td>$a $b</td><td><a href='$ori_url'>Original URL</a></td><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/$file\">$name</a></td></tr>" >> url.tmp
                done
            else
                echo "<tr><td>____________________</td><td></td><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/$file\">$file</a></td></tr>" >> url.tmp
            fi

        fi
    done
}

echo "" > url.tmp
read_dir "."
cat url.tmp |LC_ALL=C  sort -t'<' -rk 1 >> index.html
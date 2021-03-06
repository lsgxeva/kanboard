#!/bin/bash

app_css="base links title table form button alert tooltip header board project task comment subtask markdown listing activity dashboard pagination popover confirm sidebar responsive"
vendor_css="jquery-ui-1.10.4.custom chosen.min fullcalendar.min font-awesome.min"

app_js="base board calendar task analytic init"
vendor_js="jquery-1.11.1.min jquery-ui-1.10.4.custom.min jquery.ui.touch-punch.min chosen.jquery.min moment.min fullcalendar.min app.min"

function merge_css {

    local dst_file="assets/css/app.css"

    rm -f $dst_file 2>/dev/null
    echo "/* DO NOT EDIT: auto-generated file */" > $dst_file
    
    for file in $vendor_css; do cat "assets/css/vendor/${file}.css" >> $dst_file; done
    for file in $app_css; do cat "assets/css/src/${file}.css" >> $dst_file; done
}

function minify_js {

    local tmp_file="assets/js/minify.js"
    local dst_file="assets/js/vendor/app.min.js"

    rm -f $dst_file $tmp_file 2>/dev/null

    for file in $app_js; do cat "assets/js/src/${file}.js" >> $tmp_file; done

    curl -s \
        -d compilation_level=SIMPLE_OPTIMIZATIONS \
        -d output_format=text \
        -d output_info=compiled_code \
        --data-urlencode "js_code@${tmp_file}" \
        http://closure-compiler.appspot.com/compile > $dst_file

    rm -f $tmp_file 2>/dev/null
}

function merge_js {

    local tmp_file="assets/js/vendor/app.min.js"
    local dst_file="assets/js/app.js"

    rm -f $dst_file 2>/dev/null
    
    for file in $vendor_js; do cat "assets/js/vendor/${file}.js" >> $dst_file; done

    rm -f $tmp_file 2>/dev/null
}

merge_css
minify_js
merge_js

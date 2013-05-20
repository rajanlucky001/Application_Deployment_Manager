// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require_tree .

var id = 1;
var count = id;
$(document).ready(function(){
    id = parseInt(document.getElementById("count").value);
    count = id;
})

function add_new_txt_boxes(){
    if($("div[id^='txt_']").length <100){
        id = id + 1;
        count = count + 1;
        $('#param_count').attr('value',count);
        var append_data = '<tr><td><input type="text" id="prop_'+id+'" name="version[key'+id+']" size="50"/></td><td><input type="text" id="value_'+id+'" name="version[value'+id+']" size="50"/></td><td><img src="/assets/remove.png" onclick="removeRow(this);" class="remove" width="24" height="24"/></td></tr>';
        $("#text_boxes").append(append_data); //append new text box in main div
    } else {
        alert("Maximum 100 textboxes are allowed");
    }
}


function removeRow(src)
{
    count = count - 1;
    var oRow = src.parentElement.parentElement;
    document.getElementById("tbl").deleteRow(oRow.rowIndex);
    $('#param_count').attr('value',count);
}
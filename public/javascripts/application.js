function changeImages() {
  if (document.images) {
    for (var i=0; i<changeImages.arguments.length; i+=2) {
      document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
    }
  }
} 

lastOpen="";
function show(personID){
  hide();
  document.getElementById(personID+"_leader_status").style.display='inline';
  lastOpen=personID;
}

function hide(){
  if (lastOpen!==""){
  document.getElementById(lastOpen+"_leader_status").style.display='none';
  }
}

$(function () {
  $('#search_type').bind('change', function() { window.location.pathname = $(this).val() });
  $('#activity_periodBegin').datepicker(); 
});
function upload(){
const foodId = document.getElementById('foodId');
const foodItem = document.getElementById('foodItem');
const price = document.getElementById('price');
const ingr = document.getElementById('ingr');
const nutr = document.getElementById('nutr');
const addBtn = document.getElementById('addBtn');
const updateBtn =document.getElementById('updateBtn');
const removeBtn = document.getElementById('removeBtn');
var checkedValue = document.querySelector('.custom-option.selected').getAttribute("data-value");
 var image = document.getElementById('image').files[0];
  var imageName=image.name;
    var storageRef=firebase.storage().ref('images/'+imageName);
    var uploadTask=storageRef.put(image);

console.log(checkedValue)
 uploadTask.on('state_changed',function(snapshot){
         //get task progress by following code
         var progress=(snapshot.totalBytesesTransferred/snapshot.totalBytes)*100;
         console.log("upload is "+progress+" done");
    },function(error){
   
      console.log(error.message);
    },function(){
       
        uploadTask.snapshot.ref.getDownloadURL().then(function(downloadURL){

firebase.firestore().collection('Foodmenu').doc(foodId.value).set({
                food_item: foodItem.value,
	price: parseFloat(price.value),
	ingrediants: ingr.value,
	nutritions: nutr.value,
                 imageURL:downloadURL,
                 category:checkedValue
           },function(error){
               if(error){
                   alert("Error while uploading");
               }else{
                   alert("Successfully uploaded");
                  }
                   document.getElementById('post-form').reset();
                   getdata();

               
           });
        });
    });

}

window.onload=function(){
    this.getdata();
}

function getdata(){
  var checkedValue = document.querySelector('.custom-option.selected').getAttribute("data-value");

    firebase.firestore().collection('Foodmenu').where('category','==',checkedValue).get().then(function(snapshot){

      //get your posts div
      var posts_div=document.getElementById('posts');
      //remove all remaining data in that div
      posts_div.innerHTML="";
      //get data from firebase
      var data= snapshot.docs;
      console.log(data);
      
      data.forEach(doc=>{
        data = doc.data()
        posts_div.innerHTML="<div class='col-sm-4 mt-2 mb-1'>"+
         

        "<img src='"+data.imageURL+"' style='height:250px;'></br>"+

        "<div class='card-body'><p class='card-text'> </br><b>Food category:</b> " +data.category+"</p>"+ 
        "<div class='card-body'><p class='card-text'></br><b>Food Item:</b> "+data.food_item+"</p>"+
        "<div class='card-body'><p class='card-text'></br><b>Price:</b> "+data.price+"</p>"+
         "<div class='card-body'><p class='card-text'></br><b>Ingrediants:</b> "+data.ingrediants+"</p>"+
          "<div class='card-body'><p class='card-text'></br><b>Nutrotions:</b> "+data.nutritions+"</p>"+
        "<button class='btn waves-effect red darken-1' id='"+doc.id+"' onclick='delete_post(this.id)'>Delete</button>"+
        "</div></div></div>"+posts_div.innerHTML;
      });
    
    });
}          


function delete_post(key){
    firebase.firestore().collection('Foodmenu').doc(key).delete();
    getdata();

}


document.querySelector('.custom-select-wrapper').addEventListener('click', function() {
    this.querySelector('.custom-select').classList.toggle('open');

})
for (const option of document.querySelectorAll(".custom-option")) {
    option.addEventListener('click', function() {
        if (!this.classList.contains('selected')) {

            this.parentNode.querySelector('.custom-option.selected').classList.remove('selected');
            this.classList.add('selected');
            this.closest('.custom-select').querySelector('.custom-select__trigger span').textContent = this.textContent;
        getdata();
        }
    })
}
window.addEventListener('click', function(e) {

    const select = document.querySelector('.custom-select')
    if (!select.contains(e.target)) {
        select.classList.remove('open');
    }

});

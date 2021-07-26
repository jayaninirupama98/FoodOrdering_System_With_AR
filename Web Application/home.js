
window.onload=function(){
    this.getdata();
}


function getdata(){
  

    firebase.firestore().collection('Foodmenu').get().then(function(snapshot){

      
      var posts_div=document.getElementById('posts');
      console.log(posts_div);
   
      posts_div.innerHTML="";
    
      var data= snapshot.docs;
      console.log(data);
      //now pass this data to our posts div
      //we have to pass our data to for loop to get one by one
      //we are passing the key of that post to delete it from database
      data.forEach(doc=>{
        data = doc.data()
        posts_div.innerHTML="<div class='col-4  my-food-list'>"+
        
        "<img src='"+data.imageURL+"' style='height:250px;' /></br>"+

        "<div class='card-body'><p class='card-text'> </br><b>Food category:</b> " +data.category+"</p>"+ 
        "<p class='card-text'></br><b>Food Item:</b> "+data.food_item+"</p>"+
        "<p class='card-text'></br><b>Price:</b> "+data.price+"</p>"+
         "<p class='card-text'></br><b>Ingrediants:</b> "+data.ingrediants+"</p>"+
          "<p class='card-text'></br><b>Nutritions:</b> "+data.nutritions+"</p>"+
     
        "</div></div>"+posts_div.innerHTML;
      });
      // posts_div.innerHTML=posts_div.innerHTML+"</div>"
    
    });
}             


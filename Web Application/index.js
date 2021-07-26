firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    // User is signed in.

    document.getElementById("user_div").style.display = "block";
    document.getElementById("login_div").style.display = "none";

    var user = firebase.auth().currentUser;

    if(user != null){

      var email_id = user.email;
      document.getElementById("user_para").innerHTML = "Welcome User : " + email_id;

    }

  } else {
    // No user is signed in.

    if (document.getElementById("user_div"))
      document.getElementById("user_div").style.display = "none";
    if (document.getElementById("login_div"))
      document.getElementById("login_div").style.display = "block";

  }
});

function login(){

  var userEmail = document.getElementById("email_field").value;
  var userPass = document.getElementById("password_field").value;

  firebase.auth().signInWithEmailAndPassword(userEmail, userPass).then(function(data) {
    // Handle Errors here.
    console.log(data);
     window.alert("Logged In successfully");
    sessionStorage.setItem("isUserLoggedIn", true)

    window.location.replace("home.html");

    // ...
  })
  .catch(function(error) {
    // Handle Errors here.
    var errorCode = error.code;
    var errorMessage = error.message;

    window.alert("Error : " + errorMessage);

    // ...
  });

}

function toggleMenu(){
  let navigation =  document.querySelector('.navigation');
  let toggle =  document.querySelector('.toggle');
  navigation.classList.toggle('active');
  toggle.classList.toggle('active');
}

 function RegisterUser() {
   var fname=document.getElementById('fname').value;
   var lname=document.getElementById('lname').value;
   var email=document.getElementById('email').value;
   var num=document.getElementById('num').value;
   var address=document.getElementById('address').value;
  var password=document.getElementById('password').value;
   firebase.auth().createUserWithEmailAndPassword(email,password).then(function(){
   alert('User Register successfully');
    var id=firebase.auth().currentUser.uid;
    firebase.firestore().collection('Users').doc(id).set({
     Firstname:fname,
     Lastname:lname,
     Number:num,
     Address:address,
    });



   }).catch(function(error){

    var errorcode=error.code;
    var errormsg=error.message;

   });
  }
  function LoginUser(){
   var email=document.getElementById('email').value;
   var password=document.getElementById('password').value;
   firebase.auth().signInWithEmailAndPassword(email,password).then(function(){


    var id=firebase.auth().currentUser.uid;
    window.location.replace("file:///C:/Users/jayan/OneDrive/Desktop/web%20Resturent/profile.html");
    localStorage.setItem('id',id);
    

   }).catch(function(error){

    var errorCode=error.code;
    var errorMsg=error.message;

   });
  }


function logout(){
  firebase.auth().signOut();
  
  window.location.replace("./index.html");

}

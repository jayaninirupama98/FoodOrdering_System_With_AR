  var db = firebase.firestore();
var ordersRef = db.collection("orders");







      function LoadData(){
        ordersRef.get().then(function(querySnapshot) {
            LoadTableData(querySnapshot)
        });
      }

      function LoadTableData(querySnapshot){
        var tableRow='';
        querySnapshot.forEach(function(doc) {
            var document = doc.data();
        
            tableRow +='<tr>';
            tableRow += '<td class="tableId">' + document.tableId + '</td>';
          
            tableRow += '<td class="status">' + document.status + '</td>';
             tableRow += '</tr>';
       
        
        });
        $('tbody.tbodyData').html(tableRow);
      }

 $("tbody.tbodyData").on("click","td.editOrder", function(){
        console.log(document.getElementById("food-items-id").innerHTML )
        $('.orderForm').css("display", "block");
        $('#dynamicBtn').text('Update Status');

        $("#tableId").val($(this).closest('tr').find('.tableId').text());
        
        $("#status").val($(this).closest('tr').find('.status').text());
        document.getElementById("dynamicBtn").addEventListener("click", ()=>{
            console.log(document.getElementById("status").value)
            ordersRef.doc(document.getElementById("food-items-id").innerHTML).update({
                status:document.getElementById("status").value
            }).then(data=>{
                window.location.reload();

                $('.orderForm').css("display", "none");
            })
        });
       
    });

    $("tbody.tbodyData").on("click","td.deleteOrder", function(){

    

            var id=$(this).closest('tr').find('#food-items-id').text();
            console.log(id)
            ordersRef.doc(id).delete().then(data=>{
                window.location.reload();

                $('.orderForm').css("display", "none");
            })
  

    });

   $('#cancel').click(function(){
        $('.orderForm').css("display", "none");
    });





ordersRef.get().then(function(querySnapshot) {
            var tableRow='';
            querySnapshot.forEach(function(doc) {
                var document = doc.data();
                // console.log(JSON.stringify(document))
                document.foodItems.forEach(function(foodItems,index){
                    if(index==0){
                        tableRow +='<tr>';
                        tableRow +='<td id="food-items-id">'+doc.id+'</td>';

                        tableRow += '<td class="tableId">' + document.tableId+ '</td>';
                        tableRow += '<td class="foodItems">' +foodItems.foodId + '</td>';
                        tableRow += '<td class="foodItems">' + foodItems.quantity + '</td>';
                        tableRow += '<td class="status">' + document.status + '</td>';
                        tableRow += '<td class="editOrder"><i class="fa fa-pencil" aria-hidden="true" style="color:green"></i></td>'
                        tableRow += '<td class="deleteOrder"><i class="fa fa-trash" aria-hidden="true" style="color:red"></i></td>'
                    
                    
                    }else{
                        tableRow +='<tr>';
                        tableRow += '<td class="tableId">' + ""+ '</td>';
                        tableRow += '<td class="foodItems">' +foodItems.foodId + '</td>';
                        tableRow += '<td class="foodItems">' + foodItems.quantity + '</td>';
                        tableRow += '<td class="status">' + "" + '</td>';
                        tableRow += '<td class="editOrder"></td>'
                        tableRow += '<td class="deleteOrder"></td>'
                    }
                    
                  
                    tableRow += '</tr>';
                })
                
            });
            $('tbody.tbodyData').append(tableRow);
        });



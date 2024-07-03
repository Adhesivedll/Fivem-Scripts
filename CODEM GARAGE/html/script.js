





$(document).ready(function () {
  $("#searchvehicle").on("keyup", function () {
    var value = $(this).val().toLowerCase();
    $(".selectedvehicle  .vehiclemodel").filter(function () {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});

let lastimpound

window.addEventListener('message', function (event) {
  var data = event.data;

  if (data.action == 'open') {

    closepage();
    
    
    $('.container').css('display', 'block');
    if(data.sellcar == false){
      $('.sellprice').css('display', 'none')
    }else{
      $('.sellprice').css('display', 'block')
    }
    if (data.transferCar== false){
      $('.transfer').css('display', 'none')
      
    }else{
      $('.transfer').css('display', 'block')
    }
  
  

    $(".selectedvehicle").append(
      `
              
            <div class="vehiclemodel"  data-plate="${data.plate}" data-impound="${data.impound}"   data-damage = "${data.damage}" data-carmodel = "${data.spawnkod}"   data-stored = "${data.stored}"  data-body = "${data.body}" data-fuellevel = "${data.fuellevel}"  data-fiyat ="${data.vehicleprice}" data-hash ="${data.carhash}" data-garajtype="${data.garaj}">
            <img class="hoverpng" src="./images/hower.png" alt="">
            <img class="hovergri" src="./images/howergri.png" alt="">
            <div class="vehicleimage">
              <img src="./vehicleimage/${data.model}.png" alt="">
            </div>
           <h2 class="deneme" >${data.brand}</h2>
           <h3 >${data.name}</h3>
           <div class="spawnselectcar"> Select Car</div>
       
            </div> 
      
            `);
         

  } else if (data.action == "notify") {
    notify(data.message, data.type)
  }else if (data.action == 'reset'){

    $(".selectedvehicle").html('')
  }


});


function closepage() {
  $('.vehicleprice').css('display', 'none');
  $('.priceyes').css('display', 'none');
  $('.transferyes').css('display', 'none');
  $('.platevehicle').css('display', 'none');
  $('.damagevehicle').css('display', 'none');
  $('.bodyhealth').css('display', 'none');
  
}


function openPage() {
  $('.vehicleprice').css('display', 'block');
  $('.bodyhealth').css('display', 'block');
  $('.platevehicle').css('display', 'block');
  $('.damagevehicle').css('display', 'block');
}


let lastplate
let lasthash
let lastprice
let laststored
let lastgaraj 
let lastmodel

$(document).on("click", ".spawnselectcar", function () {
  openPage();
  let garajtip = $(this).parent().attr("data-garajtype");
  lastgaraj = garajtip
  let plate = $(this).parent().attr("data-plate");
  let damage = $(this).parent().attr("data-damage");
  let vehicleprice = $(this).parent().attr("data-fiyat");
  let bodydamage = $(this).parent().attr("data-body");
  let hash = $(this).parent().attr("data-hash");
  let stored = $(this).parent().attr("data-stored");
  let model = $(this).parent().attr("data-carmodel");
  let impounds = $(this).parent().attr("data-impound");
  lastmodel = model;
  lasthash = hash;
  laststored = stored;
  let damagee = parseInt(damage);
  $('.hoverpng').css('display', 'none');
  $('.hovergri').css('display', 'block');
  $('.hoverpng').css('transform', 'scale(0.5)');
  let image = $(this).parent().find('.hoverpng');
  let damageee = damagee.toFixed(0);
  let fuellevel = $(this).parent().attr("data-fuellevel");
  let fuell = parseInt(fuellevel);
  let fuelll = fuell.toFixed(0);
  lastplate = plate
  lastprice = vehicleprice
  $('.vehicleprice').text('$ ' + vehicleprice);
  $('.platevehicle').text(plate);
   let bodyy = parseInt(bodydamage);
  let body = bodyy.toFixed(0);
  $('.bodyhealth').text('% ' + body);
  $(".damagevehicle").text(damageee + '%');
  $(".fuellevel").text(fuelll + ' LITERS');

  if (garajtip == 1){
  
    if (stored == 1) {
    
      $(".stored").text('Parked')
      $('.vehiclestoredpng').attr('src','./images/park.png');  
    } else {
      $(".stored").text('Outside')
      $('.vehiclestoredpng').attr('src','./images/outveh.png');  
    }
  }else{
   

    if(impounds == 'true'){
      laststored = 0
      $(".stored").text('Outside')
      $('.vehiclestoredpng').attr('src','./images/outveh.png');  
    }else {
      laststored = 1
      $(".stored").text('Parked')
      $('.vehiclestoredpng').attr('src','./images/park.png');  
    }
      // $(".stored").text('Outside')
      // $('.vehiclestoredpng').attr('src','./images/outveh.png');  
   
      // $(".stored").text('Parked')
      // $('.vehiclestoredpng').attr('src','./images/park.png');  
   
     
    
  }
 
  image.css('display', 'block');
  setTimeout(function () {
    image.css('transform', 'scale(1.0)')
  }, 10)
  
    

})

$(document).on("click", "#spawncar", function () {

  if (laststored == '0') {
    notify("The car is not in the garage !", "error")
  } else {
    $.post('https://codem-garage/spawnvehicle', JSON.stringify({ plate: lastplate , model : lastmodel}));
    $('.container').css('display', 'none')
    $.post('https://codem-garage/closepage', JSON.stringify({}));
    lastplate = null;
    document.querySelectorAll(".vehiclemodel").forEach(function (a) { a.remove() })
  }


})


$(document).on("click", ".closeimg", function () {
  $('.container').css('display', 'none')
  $.post('https://codem-garage/closepage', JSON.stringify({}));
  lastplate = null;
 
  document.querySelectorAll(".vehiclemodel").forEach(function (a) { a.remove() })
})

$(document).on("click", ".sellpricecar", function () {
  $('.sellprice').css('display', 'none');
  $('.priceyes').css('display', 'block');
})

$(document).on("click", ".priceyesbutton", function () {
  $('.sellprice').css('display', 'block');
  $('.priceyes').css('display', 'none');
})



$(document).on("click", ".transfertovehicle", function () {


  const id = $('#transfer').val();
  if (!isNaN(id) && id != '') {
    if (typeof (lastplate != 'undefined')) {
      $.post('https://codem-garage/transfervehicle', JSON.stringify({plate: lastplate,id: id }));
      $('.container').css('display', 'none')
      $.post('https://codem-garage/closepage', JSON.stringify({}));
      lastplate = null;
      document.querySelectorAll(".vehiclemodel").forEach(function (a) { a.remove() })
    } else {
      notify("Choose a vehicle", "error")
    }
  } else {

    notify("ID giriniz ", "error")
  }
})

$(document).on("click", ".transferyescar", function () {
  $('.transfer').css('display', 'block');
  $('.transferyes').css('display', 'none');

})

$(document).on("click", ".pricebutton", function () {

  $.post('https://codem-garage/sellvehicle', JSON.stringify({
    plate: lastplate,
    hash: lasthash,
    price: lastprice
  }), function (sell) {
    if (sell == true) {
      notify("This vehicle cannot be sold", "error")

    } else {
      $('.container').css('display', 'none')
      $.post('https://codem-garage/closepage', JSON.stringify({}));
      lastplate = null;
      document.querySelectorAll(".vehiclemodel").forEach(function (a) { a.remove() })
    }
  });
})


$(document).keydown(function (e) {
  if (e.keyCode == 27) {
    $('.container').css('display', 'none')
    $.post('https://codem-garage/closepage', JSON.stringify({}));
    lastplate = null;
    document.querySelectorAll(".vehiclemodel").forEach(function (a) { a.remove() })

  }
});




notify = function (text, type) {
  $(".notify").fadeOut(0)
  let renk = "#333"
  if (type == "error") {
    renk = "#FF3131"
  } else if (type == "success") {
    renk = "#689f38"
  }

  $(".notify").fadeIn(100)
  $(".notify").html(text)
  $(".notify").css("background", renk);
  $(".notify").fadeOut(3000)
}

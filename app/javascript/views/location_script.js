
function showPosition(position) {
    let lat = position.coords.latitude;
    let lng = position.coords.longitude;
    let geocoder = new google.maps.Geocoder;
    let latlng = {lat: parseFloat(lat), lng: parseFloat(lng)};

    geocoder.geocode({'location': latlng}, function(results, status) {
        if (status === 'OK' && results[0]) {
            let fullAddress = results[0].formatted_address;
            let address = fullAddress.replace(/日本、〒\d{3}-\d{4} /, '');

            document.getElementById('hidden_address').value = address;
            document.getElementById('location_form').submit();
        }
    });
}

document.getElementById('location_form').addEventListener('submit', function(event) {
    if (!document.getElementById('hidden_address').value) {
        event.preventDefault();
        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(showPosition, showError);
        }
    }
});

function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            window.alert("位置情報を取得できませんでした。ブラウザまたはデバイスのGPS設定を確認してください。");
            break;
        case error.POSITION_UNAVAILABLE:
            window.alert("ジオロケーションは利用できません。ブラウザまたはデバイスの設定を確認してください。");
            break;
        case error.TIMEOUT:
            window.alert("位置情報の取得タイムアウトしました。");
            break;
    }
    closeModal();
}

function closeModal() {
    document.getElementById('modal').classList.add('hidden');
    document.getElementById('my_modal_2').close();
}

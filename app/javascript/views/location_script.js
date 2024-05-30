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

document.addEventListener('turbo:load', function() {
    document.getElementById('location_form').addEventListener('submit', function(event) {
        if (!document.getElementById('hidden_address').value) {
            event.preventDefault();
            if ("geolocation" in navigator) {
                navigator.geolocation.getCurrentPosition(showPosition);
            }
        }
    });
});

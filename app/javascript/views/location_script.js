function showPosition(position) {
    let lat = position.coords.latitude;
    let lng = position.coords.longitude;
    let geocoder = new google.maps.Geocoder;
    let latlng = {lat: parseFloat(lat), lng: parseFloat(lng)};

    geocoder.geocode({'location': latlng}, function(results, status) {
        if (status === 'OK' && results[0]) {
            let fullAddress = results[0].formatted_address;
            let address = fullAddress.replace(/日本、〒\d{3}-\d{4} /, '');

            let hiddenAddressElement = document.getElementById('hidden_address');
            let formElement = document.getElementById('location_form');
            if (hiddenAddressElement && formElement) {
                hiddenAddressElement.value = address;
                formElement.submit();
            } else {
                console.error('Hidden address input or form not found');
            }
        }
    });
}

document.addEventListener('turbo:load', function() {
    let form = document.getElementById('location_form');
    let hiddenAddress = document.getElementById('hidden_address');

    if (form && hiddenAddress) {
        form.addEventListener('submit', function(event) {
            if (!hiddenAddress.value) {
                event.preventDefault();
                if ("geolocation" in navigator) {
                    navigator.geolocation.getCurrentPosition(showPosition);
                }
            }
        });
    } else {
        if (!form) console.error('Form not found');
        if (!hiddenAddress) console.error('Hidden address input not found');
    }
});

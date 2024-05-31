document.addEventListener('turbo:load', function() {
    var form = document.getElementById('location_form');
    var modal = document.getElementById('my_modal_2');

    if (form && modal) {
        form.addEventListener('submit', function(event) {
            modal.showModal();
        });
    } else {
        console.error('Form or modal not found');
    }
});
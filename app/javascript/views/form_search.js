document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('location_form');
    var modal = document.getElementById('my_modal_2');

    form.addEventListener('submit', function(event) {
        modal.showModal();
    });
});
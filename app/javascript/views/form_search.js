document.addEventListener('turbo:load', function() {
    var form = document.getElementById('location_form');
    var modal = document.getElementById('my_modal_2');

    if (form) {
        if (modal) {
            form.addEventListener('submit', function(event) {
                event.preventDefault();
                modal.showModal();
            });
        } else {
            console.error('Modal not found');
        }
    } else {
        console.error('Form not found');
    }
});

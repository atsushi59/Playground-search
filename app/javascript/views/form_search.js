document.addEventListener('turbo:load', function() {
    var form = document.getElementById('location_form');
    var modal = document.getElementById('my_modal_2');

    if (form && modal) {
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            modal.showModal();
        });
    } else {
        if (!form) {
            console.log('Form not found');
        }
        if (!modal) {
            console.log('Modal not found');
        }
    }
});

document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('location_form');
    var modal = document.getElementById('my_modal_2');

    form.addEventListener('submit', function(event) {
        event.preventDefault();
        modal.showModal();
    });
});

function openModal() {
    document.getElementById('modal').classList.remove('hidden');
}

function closeModal() {
    document.getElementById('modal').classList.add('hidden');
}

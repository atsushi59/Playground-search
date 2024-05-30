document.addEventListener('turbo:load', function() {
    const forms = document.querySelectorAll('.new_tab_form');
    forms.forEach(form => {
        form.addEventListener('submit', function(event) {
        event.preventDefault();
        const formData = new FormData(form);
        const destination = form.querySelector('input[name="destination"]').value;

        fetch(form.action, {
            method: 'POST',
            body: formData,
            headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            }
        })
        .then(response => {
            window.open(destination, '_blank');
            return response.json();
        })
        .then(data => {
            if (data.error) {
            console.error('Error:', data.error);
            }
        })
        .catch(error => console.error('Error:', error));
        });
    });
});

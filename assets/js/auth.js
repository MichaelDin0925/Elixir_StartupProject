// assets/js/auth.js
document.addEventListener('DOMContentLoaded', function () {
    const signInForm = document.getElementById('sign-in-form');
    const signUpForm = document.getElementById('sign-up-form');
    const showSignUpLink = document.getElementById('show-sign-up');
    const showSignInLink = document.getElementById('show-sign-in');

    showSignUpLink.addEventListener('click', function (event) {
        event.preventDefault();
        signInForm.style.display = 'none';
        signUpForm.style.display = 'block';
    });

    showSignInLink.addEventListener('click', function (event) {
        event.preventDefault();
        signUpForm.style.display = 'none';
        signInForm.style.display = 'block';
    });

    // Handle sign in form submission
    signInForm.addEventListener('submit', function (event) {
        event.preventDefault();
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        // Make an API call to sign in
        fetch('/api/sign_in', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username, password })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Handle successful sign in
                    alert('Sign in successful');
                } else {
                    // Handle sign in error
                    alert('Sign in failed: ' + data.error);
                }
            });
    });

    // Handle sign up form submission
    signUpForm.addEventListener('submit', function (event) {
        event.preventDefault();
        const newUsername = document.getElementById('new-username').value;
        const email = document.getElementById('email').value;
        const newPassword = document.getElementById('new-password').value;

        // Make an API call to sign up
        fetch('/api/sign_up', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username: newUsername, email, password: newPassword })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Handle successful sign up
                    alert('Sign up successful');
                } else {
                    // Handle sign up error
                    alert('Sign up failed: ' + data.error);
                }
            });
    });
});

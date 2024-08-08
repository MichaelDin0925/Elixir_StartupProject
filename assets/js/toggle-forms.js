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
});

const wrapper = document.querySelector('.wrapper');
const tologin = document.querySelector('.to-login');
const toregis = document.querySelector('.to-regis');
const login = document.querySelector('.btnlogin');
const closelogin = document.querySelector('.close');

toregis.addEventListener('click', ()=> {
    wrapper.classList.add('active');
})
tologin.addEventListener('click', ()=> {
    wrapper.classList.remove('active');
})
login.addEventListener('click', ()=> {
    wrapper.classList.add('active-popup');
})
closelogin.addEventListener('click', ()=> {
    wrapper.classList.remove('active-popup');
})
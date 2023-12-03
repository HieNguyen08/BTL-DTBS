var newMemberAddBtn = document.querySelector('.addMemberBtn'),
darkBg = document.querySelector('.dark_bg'),
popupForm = document.querySelector('.popup'),
crossBtn = document.querySelector('.closeBtn'),
submitBtn = document.querySelector('.submitBtn'),
modalTitle = document.querySelector('.modalTitle'),
popupFooter = document.querySelector('.popupFooter'),
form = document.querySelector('form'),
formInputFields = document.querySelectorAll('form input'),
name = document.querySelectorAll('name'),
type = document.querySelectorAll('type'),
language = document.querySelectorAll('language'),
author = document.querySelectorAll('author'),
rating = document.querySelectorAll('rating'),
entries = document.querySelector(".showEntries"),
tabSize = document.getElementById("table_size"),
userInfo = document.querySelector(".userInfo"),
table = document.querySelector("table"),
filterData = document.getElementById("search")
let originalData = localStorage.getItem('userProfile') ? JSON.parse(localStorage.getItem('userProfile')) : []
let getData = [...originalData]
let isEdit = false, editId
var arrayLength = 0
var tableSize = 10
var startIndex = 1
var endIndex = 0
var currentIndex = 1
var maxIndex = 0
newMemberAddBtn.addEventListener('click', ()=> {
    isEdit = false
    submitBtn.innerHTML = "Submit"
    modalTitle.innerHTML = "Fill the Form"
    popupFooter.style.display = "block"
    darkBg.classList.add('active')
    popupForm.classList.add('active')
})
crossBtn.addEventListener('click', ()=>{
    darkBg.classList.remove('active')
    popupForm.classList.remove('active')
    form.reset()
})
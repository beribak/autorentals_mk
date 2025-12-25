import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fleet-faq"
export default class extends Controller {
  static targets = ["question", "answer", "mobileAnswer"]

  selectQuestion(event) {
    const clickedQuestion = event.currentTarget
    const faqItem = clickedQuestion.closest('.fleet-faq-item')
    const faqId = faqItem.dataset.faq
    const clickedMobileAnswer = faqItem.querySelector('.faq-mobile-answer')
    
    // Check if the clicked question is already active (for mobile toggle)
    const wasActive = clickedQuestion.classList.contains('active')
    
    // Remove active class from all questions
    this.questionTargets.forEach(question => {
      question.classList.remove('active')
    })
    
    // Hide all mobile answers
    this.mobileAnswerTargets.forEach(answer => {
      answer.classList.remove('active')
    })
    
    // Hide all desktop answers
    this.answerTargets.forEach(answer => {
      answer.classList.remove('active')
    })
    
    // If not already active, activate this question
    if (!wasActive) {
      // Add active class to clicked question
      clickedQuestion.classList.add('active')
      
      // Show mobile answer
      if (clickedMobileAnswer) {
        clickedMobileAnswer.classList.add('active')
      }
      
      // Show corresponding desktop answer
      const activeAnswer = this.answerTargets.find(answer => 
        answer.dataset.faq === faqId
      )
      
      if (activeAnswer) {
        activeAnswer.classList.add('active')
      }
    }
  }
}

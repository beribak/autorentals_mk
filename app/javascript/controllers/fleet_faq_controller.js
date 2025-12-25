import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fleet-faq"
export default class extends Controller {
  static targets = ["question", "answer"]

  selectQuestion(event) {
    const clickedQuestion = event.currentTarget
    const faqId = clickedQuestion.dataset.faq
    
    // Remove active class from all questions
    this.questionTargets.forEach(question => {
      question.classList.remove('active')
    })
    
    // Hide all answers
    this.answerTargets.forEach(answer => {
      answer.classList.remove('active')
    })
    
    // Add active class to clicked question
    clickedQuestion.classList.add('active')
    
    // Show corresponding answer
    const activeAnswer = this.answerTargets.find(answer => 
      answer.dataset.faq === faqId
    )
    
    if (activeAnswer) {
      activeAnswer.classList.add('active')
    }
  }
}

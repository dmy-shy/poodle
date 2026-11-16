document.querySelectorAll('[data-quiz]').forEach((quiz) => {
  const feedback = quiz.querySelector('[role="status"]');
  quiz.querySelectorAll('button[data-feedback]').forEach((button) => {
    button.addEventListener('click', () => {
      feedback.textContent = button.dataset.feedback;
    });
  });
});

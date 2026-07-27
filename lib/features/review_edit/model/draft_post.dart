class DraftPost {
  const DraftPost({
    required this.sourceTag,
    required this.articleTitle,
    required this.articleUrl,
    required this.body,
  });

  final String sourceTag;
  final String articleTitle;
  final String articleUrl;
  final String body;
}

abstract class DraftPostMock {
  static const DraftPost sample = DraftPost(
    sourceTag: 'TechCrunch',
    articleTitle: 'Meta releases Llama 4',
    articleUrl: 'https://techcrunch.com/meta-llama-4',
    body:
        "Meta just dropped Llama 4 — and it's rewriting the rules of "
        "open-source AI.\n\n"
        "Here's what you need to know:\n\n"
        "🔹 Llama 4 outperforms GPT-4o on most public benchmarks\n"
        "🔹 The model is fully open-weight — anyone can fine-tune it\n"
        "🔹 Meta is betting that open AI beats closed AI long-term\n\n"
        "For engineers, this is a massive unlock. Fine-tuning a frontier "
        "model on your own data used to cost six figures. Now it doesn't.\n\n"
        "The real question: will enterprises actually adopt open-weight "
        "models when liability is still murky?\n\n"
        "Drop your take below 👇\n\n"
        "#AI #OpenSource #LLM #Meta #MachineLearning #SoftwareEngineering",
  );
}

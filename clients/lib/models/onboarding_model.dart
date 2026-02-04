class OnboardingModel {
  final String title;
  final String description;
  final String image; // Add this
  final String buttonText;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
    required this.buttonText,
  });
}

final List<OnboardingModel> onboardingpages = [
  OnboardingModel(
    image: "assets/images/qoljiif.png",
    title: "Experience Premium\nLiving & Working",
    description:
        "The ultimate platform to manage your hotel stays, book event halls, and secure private offices effortlessly.",
    buttonText: "Next →",
  ),
  OnboardingModel(
    image: "assets/images/qoljiif.png",
    title: "Versatile Spaces for\nEvery Need",
    description:
        "Book event halls for celebrations or luxury rooms for travel.",
    buttonText: "Next",
  ),
  OnboardingModel(
    image: "assets/images/qoljiif.png",
    title: "Professional Workspaces",
    description:
        "Secure quiet, fully-equipped private offices for optimal productivity and focus.",
    buttonText: "Get Started",
  ),
];

class FamilyMember {
  FamilyMember({
      required this.name, 
      required this.imagePath, 
      this.isActive = true,
  });
  

  final String name;
  final String imagePath;
  final bool isActive;

}

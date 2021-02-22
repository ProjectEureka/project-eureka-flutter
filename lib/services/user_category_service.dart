class UserCategoryService {
  Future<List> getCategories() async {
    // List of another 2 dummy questions (different)
    List<String> userCategories = ["Lifestyle", "Technology"];
    return userCategories;
  }
}

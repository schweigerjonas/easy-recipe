import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final int cookingTime;
  final String thumbnailUrl;
  final VoidCallback onTap;
  final VoidCallback markAsFavorite;
  final int id;
  final bool loggedInState;
  final int userId;

  final ValueNotifier<bool> _isIconChanged = ValueNotifier<bool>(false);

  RecipeCard({
    super.key,
    required this.title,
    required this.cookingTime,
    required this.thumbnailUrl,
    required this.onTap,
    required this.markAsFavorite,
    required this.id,
    required this.loggedInState,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login required'),
        content: const Text('You need to be logged in to do this!'),
        actions: [
          TextButton(
              onPressed: markAsFavorite,
              child: const Text('LOGIN')
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.white
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _isIconChanged,
                      builder: (context, isIconChanged, child) {
                        return IconButton(
                            icon: Icon(
                              isIconChanged ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 24,
                            ),
                            onPressed: () {
                              if (loggedInState == true) {
                                _isIconChanged.value = !isIconChanged;
                              } else {
                                openDialog();
                              }
                            }
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: Colors.yellow,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text("${cookingTime}min", style: const TextStyle(color: Colors.white),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
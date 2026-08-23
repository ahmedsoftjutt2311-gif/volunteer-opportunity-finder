import 'package:flutter/material.dart';

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.indigo,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    filled: true,
  ),
);

class FadeIn extends StatefulWidget {
  final Widget child;
  const FadeIn({super.key, required this.child});
  @override State<FadeIn> createState()=>_FadeInState();
}
class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override void initState(){super.initState();c=AnimationController(vsync:this,duration:const Duration(milliseconds:450))..forward();}
  @override void dispose(){c.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>FadeTransition(
    opacity:CurvedAnimation(parent:c,curve:Curves.easeOut),child:SlideTransition(
      position:Tween(begin:const Offset(0,.04),end:Offset.zero).animate(c),child:widget.child));
}

class SectionTitle extends StatelessWidget {
  final String title,subtitle;
  const SectionTitle({super.key,required this.title,required this.subtitle});
  @override Widget build(BuildContext c)=>Padding(
    padding:const EdgeInsets.fromLTRB(20,20,20,12),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(title,style:Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
      const SizedBox(height:4),Text(subtitle)
    ]));
}

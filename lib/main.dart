import 'package:flutter/material.dart';
import 'shared.dart';
void main()=>runApp(const App());
class App extends StatelessWidget{const App({super.key});@override Widget build(BuildContext c)=>MaterialApp(debugShowCheckedModeBanner:false,theme:appTheme(),home:const Home());}
class Home extends StatefulWidget{const Home({super.key});@override State<Home> createState()=>_S();}
class _S extends State<Home>{
 final data=[['Community Clean-up','Environment','City Park',Icons.eco],['Food Distribution','Community','Community Center',Icons.volunteer_activism],['Teaching Support','Education','Learning Hub',Icons.school],['Tree Plantation','Environment','Green Zone',Icons.forest]];
 String search='',cat='All';int tab=0;
 @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Volunteer Finder'),actions:[IconButton(onPressed:()=>showAboutDialog(context:c,applicationName:'Volunteer Finder'),icon:const Icon(Icons.info_outline))]),
 body:IndexedStack(index:tab,children:[browse(c),const Center(child:Text('Saved opportunities will appear here.'))]),
 bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
 NavigationDestination(icon:Icon(Icons.explore_outlined),label:'Explore'),NavigationDestination(icon:Icon(Icons.bookmark_border),label:'Saved')]));
 Widget browse(BuildContext c){final list=data.where((x)=>(cat=='All'||x[1]==cat)&&x[0].toString().toLowerCase().contains(search.toLowerCase())).toList();
 return ListView(padding:const EdgeInsets.all(16),children:[
 SectionTitle(title:'Find an opportunity',subtitle:'Choose a cause and make an impact.'),
 TextField(onChanged:(v)=>setState(()=>search=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search opportunities')),
 const SizedBox(height:12),SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:['All','Environment','Community','Education'].map((x)=>Padding(padding:const EdgeInsets.only(right:8),child:ChoiceChip(label:Text(x),selected:cat==x,onSelected:(_)=>setState(()=>cat=x))).toList())),
 const SizedBox(height:12),...list.map((x)=>Card(child:ListTile(contentPadding:const EdgeInsets.all(14),leading:CircleAvatar(child:Icon(x[3] as IconData)),title:Text(x[0].toString()),subtitle:Text('${x[1]} • ${x[2]}'),trailing:const Icon(Icons.chevron_right),onTap:()=>showDialog(context:c,builder:(_)=>AlertDialog(title:Text(x[0].toString()),content:Text('Category: ${x[1]}\nLocation: ${x[2]}\n\nThis opportunity is ready for volunteers.'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('Close'))]))))) ]);
 }}

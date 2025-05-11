import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'water_track.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _glassTEcontroller = TextEditingController(
    text: "1",
  );
  List<WaterTrack> waterTrackList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 0,
        title: const Text("Water Tracker",style:TextStyle(fontWeight:FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildWaterTrackCounter(),
          const SizedBox(height: 24),
          Expanded(child: _buildWaterTrackListView()),
        ],
      ),
    );
  }

  Widget _buildWaterTrackListView() {
    return ListView.separated(
      itemCount: waterTrackList.length,
      itemBuilder: (context, index) {
        final WaterTrack waterTrack = waterTrackList[index];
        return _buildWaterTrackListTile(index);
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }

  Widget _buildWaterTrackListTile(int index) {
    WaterTrack waterTrack = waterTrackList[index];
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ListTile(
        title: Text(DateFormat('hh:mm a').format(waterTrack.dateTime)),
        subtitle: Text(DateFormat('d MMM yyyy').format(waterTrack.dateTime)),

        leading: CircleAvatar(child: Text("${waterTrack.noOfGlasses}")),
        trailing: IconButton(
          onPressed: () => _onTapDeleteButton(index),
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }

  Widget _buildWaterTrackCounter() {
    return Column(
      children: [
        Text(
          getTotalGlassCount().toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const Text("Glass's", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              shape: const CircleBorder(),
              elevation: 4,
              shadowColor: Colors.black26,
              color: Color(0xFFEADDFF),
              child: SizedBox(
                width: 55,
                height: 55,
                child: Center(
                  child: TextField(
                    controller: _glassTEcontroller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: _addTapAddWaterTracker,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEADDFF),
                shape: const CircleBorder(),
                elevation: 4,
                shadowColor: Colors.black26,
                padding: const EdgeInsets.all(18),
              ),
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: _onTapResetButton,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEADDFF),
                shape: const CircleBorder(),
                elevation: 4,
                shadowColor: Colors.black26,
                padding: const EdgeInsets.all(18),
              ),
              child: const Text("Reset"),
            ),
          ],
        ),
      ],
    );
  }

  int getTotalGlassCount() {
    int counter = 0;
    for (WaterTrack t in waterTrackList) {
      counter += t.noOfGlasses;
    }
    return counter;
  }

  /// logic for empty  input,if user click just on add button it will automatically add 1 glass
  void _addTapAddWaterTracker() {
    if (_glassTEcontroller.text.isEmpty) {
      _glassTEcontroller.text = "1";
    }

    ///track how many glasses of water a user has drunk and update the UI accordingly
    final int noOfGlasses = int.tryParse(_glassTEcontroller.text) ?? 1;
    WaterTrack waterTrack = WaterTrack(
      noOfGlasses: noOfGlasses,
      dateTime: DateTime.now(),
    );
    waterTrackList.add(waterTrack);
    setState(() {});
  }

  void _onTapDeleteButton(int index) {
    waterTrackList.removeAt(index);
    setState(() {});
  }

  void _onTapResetButton() {
    waterTrackList.clear();
    setState(() {});
  }
  @override
  void dispose(){
    _glassTEcontroller.dispose();
    super.dispose();
  }
}

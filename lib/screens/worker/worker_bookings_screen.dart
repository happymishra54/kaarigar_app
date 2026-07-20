import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/worker_dashboard_provider.dart';

class WorkerBookingsScreen extends StatefulWidget {
  const WorkerBookingsScreen({super.key});

  @override
  State<WorkerBookingsScreen> createState() =>
      _WorkerBookingsScreenState();
}

class _WorkerBookingsScreenState extends State<WorkerBookingsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      context
          .read<WorkerDashboardProvider>()
          .loadBookings();

    });
  }


  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<WorkerDashboardProvider>();

    final bookings =
        provider.bookings;


    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Worker Bookings",
        ),
      ),


      body: provider.loading

          ? const Center(
              child: CircularProgressIndicator(),
            )


          : bookings.isEmpty

              ? const Center(
                  child: Text(
                    "No bookings found",
                  ),
                )


              : ListView.builder(

                  padding:
                      const EdgeInsets.all(16),

                  itemCount:
                      bookings.length,


                  itemBuilder:
                      (context,index){

                    final booking =
                      bookings[index];


                    return Card(

                      elevation: 3,

                      margin:
                          const EdgeInsets.only(
                            bottom: 15,
                          ),


                      child: Padding(

                        padding:
                            const EdgeInsets.all(15),


                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,


                          children: [

                            Text(

                              booking['customer']['name']
                                  .toString(),

                              style:
                                  const TextStyle(
                                    fontSize:18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),

                            ),


                            const SizedBox(height:8),


                            Text(

                              booking['service']['title']
                                  .toString(),

                            ),


                            const SizedBox(height:8),


                            Text(

                              "Status: ${booking['status']}",

                            ),


                            const SizedBox(height:15),


                            Row(

                              children: [

                                if(booking['status']=="pending")

                                Expanded(

                                  child:
                                  ElevatedButton(

                                    onPressed: (){

                                      provider.acceptBooking(
                                        booking['id'],
                                      );

                                    },

                                    child:
                                    const Text(
                                      "Accept",
                                    ),

                                  ),

                                ),


                                if(booking['status']=="pending")

                                const SizedBox(width:10),


                                if(booking['status']=="pending")

                                Expanded(

                                  child:
                                  ElevatedButton(

                                    style:
                                    ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.red,
                                    ),

                                    onPressed: (){

                                      provider.rejectBooking(
                                        booking['id'],
                                      );

                                    },

                                    child:
                                    const Text(
                                      "Reject",
                                    ),

                                  ),

                                ),


                                if(booking['status']=="accepted")

                                Expanded(

                                  child:
                                  ElevatedButton(

                                    onPressed: (){

                                      provider.completeBooking(
                                        booking['id'],
                                      );

                                    },

                                    child:
                                    const Text(
                                      "Complete",
                                    ),

                                  ),

                                ),


                              ],

                            )

                          ],

                        ),

                      ),

                    );

                  },

                ),

    );
  }
}
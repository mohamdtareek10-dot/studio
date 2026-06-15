
"use client";

import { Navigation } from "@/components/Navigation";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Activity, Calendar, History, Star } from "lucide-react";

export default function HistoryPage() {
  const workoutHistory = [
    { date: "2024-10-23", name: "Heavy Bag Power Drills", duration: "45 min", intensity: "High", feedback: "Strong punches, need more hip rotation" },
    { date: "2024-10-21", name: "Shadow Boxing", duration: "30 min", intensity: "Medium", feedback: "Focused on speed today" },
    { date: "2024-10-20", name: "BJJ Technical Flow", duration: "60 min", intensity: "Medium", feedback: "Good session with partner" },
    { date: "2024-10-18", name: "Kettlebell Conditioning", duration: "25 min", intensity: "Very High", feedback: "Exhausted but feeling stronger" },
  ];

  return (
    <div className="min-h-screen pb-24 md:pt-20">
      <Navigation />
      <main className="max-w-5xl mx-auto px-4 py-8 space-y-8">
        <header>
          <h1 className="text-4xl font-headline font-bold text-primary">TRAINING LOGS</h1>
          <p className="text-muted-foreground">Reflect on your journey and track your consistency.</p>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <Card className="border-primary/20">
            <CardHeader>
              <CardTitle className="flex items-center gap-2"><Activity className="w-5 h-5 text-primary" /> Monthly Stats</CardTitle>
            </CardHeader>
            <CardContent className="grid grid-cols-2 gap-4">
              <div className="bg-muted p-4 rounded-lg">
                <div className="text-xs text-muted-foreground uppercase tracking-widest mb-1">Total Hours</div>
                <div className="text-2xl font-bold">24.5</div>
              </div>
              <div className="bg-muted p-4 rounded-lg">
                <div className="text-xs text-muted-foreground uppercase tracking-widest mb-1">Calories Burned</div>
                <div className="text-2xl font-bold">12,400</div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-accent/20">
            <CardHeader>
              <CardTitle className="flex items-center gap-2"><Star className="w-5 h-5 text-accent" /> Achievement Unlocked</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex items-center gap-4 bg-accent/5 p-4 rounded-lg border border-accent/20">
                <div className="w-12 h-12 bg-accent/20 rounded-full flex items-center justify-center">
                  <Trophy className="text-accent w-6 h-6" />
                </div>
                <div>
                  <h4 className="font-bold">Iron Lungs</h4>
                  <p className="text-xs text-muted-foreground">Complete 10 high-intensity sessions</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2"><History className="w-5 h-5 text-primary" /> Recent Sessions</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Date</TableHead>
                  <TableHead>Workout</TableHead>
                  <TableHead>Duration</TableHead>
                  <TableHead>Intensity</TableHead>
                  <TableHead className="hidden md:table-cell">Feedback</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {workoutHistory.map((item, idx) => (
                  <TableRow key={idx}>
                    <TableCell className="font-medium flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-muted-foreground" /> {item.date}
                    </TableCell>
                    <TableCell>{item.name}</TableCell>
                    <TableCell>{item.duration}</TableCell>
                    <TableCell>
                      <Badge 
                        variant="secondary" 
                        className={
                          item.intensity === "High" || item.intensity === "Very High" 
                            ? "bg-red-500/10 text-red-500" 
                            : "bg-primary/10 text-primary"
                        }
                      >
                        {item.intensity}
                      </Badge>
                    </TableCell>
                    <TableCell className="hidden md:table-cell text-muted-foreground italic text-sm">
                      "{item.feedback}"
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </main>
    </div>
  );
}

import { Trophy } from "lucide-react";

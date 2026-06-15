
"use client";

import { Navigation } from "@/components/Navigation";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { CheckCircle2, Flame, Timer, Target, ArrowRight, Activity, Zap } from "lucide-react";
import Link from "next/link";

export default function Dashboard() {
  const todayWorkout = {
    name: "Kickboxing Focus",
    type: "Striking",
    duration: 45,
    difficulty: "Advanced",
    drills: [
      "Dynamic Warm-up (10 min)",
      "Heavy Bag: Straight Punches (15 min)",
      "Focus Mitts: Combinations (15 min)",
      "Cool-down & Stretch (5 min)"
    ]
  };

  const currentGoals = [
    { name: "Weekly Training Hours", current: 6.5, target: 10, unit: "hrs" },
    { name: "Kickboxing Sessions", current: 3, target: 5, unit: "sessions" },
  ];

  return (
    <div className="min-h-screen pb-24 md:pt-20">
      <Navigation />
      
      <main className="max-w-7xl mx-auto px-4 py-8 space-y-8">
        <header className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-3xl font-headline font-bold text-primary tracking-tight">OSSU, WARRIOR</h1>
            <p className="text-muted-foreground">Thursday, Oct 24 • Day 12 of your current cycle</p>
          </div>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 bg-muted px-4 py-2 rounded-full border border-primary/20">
              <Flame className="text-orange-500 w-5 h-5" />
              <span className="font-bold">5 DAY STREAK</span>
            </div>
          </div>
        </header>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Workout Focus */}
          <div className="lg:col-span-2 space-y-6">
            <Card className="border-primary/50 relative overflow-hidden bg-gradient-to-br from-card to-background">
              <div className="absolute top-0 right-0 p-8 opacity-10">
                <Activity className="w-32 h-32 text-primary" />
              </div>
              <CardHeader>
                <div className="flex justify-between items-start">
                  <div>
                    <Badge variant="secondary" className="mb-2 bg-primary/20 text-primary border-primary/30 uppercase tracking-widest text-[10px]">Today's Focus</Badge>
                    <CardTitle className="text-3xl font-headline mb-1">{todayWorkout.name}</CardTitle>
                    <CardDescription className="flex items-center gap-4">
                      <span className="flex items-center gap-1"><Timer className="w-4 h-4" /> {todayWorkout.duration} mins</span>
                      <span className="flex items-center gap-1 font-bold text-primary"><Activity className="w-4 h-4" /> {todayWorkout.difficulty}</span>
                    </CardDescription>
                  </div>
                </div>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {todayWorkout.drills.map((drill, idx) => (
                    <div key={idx} className="flex items-center gap-3 p-3 bg-muted/50 rounded-lg border border-border/50">
                      <div className="w-6 h-6 rounded-full bg-primary/10 border border-primary/30 flex items-center justify-center text-primary text-xs font-bold">
                        {idx + 1}
                      </div>
                      <span className="text-sm">{drill}</span>
                    </div>
                  ))}
                </div>
                <Button className="w-full electric-glow" size="lg">
                  START WORKOUT <ArrowRight className="ml-2 w-4 h-4" />
                </Button>
              </CardContent>
            </Card>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2"><Target className="w-5 h-5 text-primary" /> Active Goals</CardTitle>
                </CardHeader>
                <CardContent className="space-y-6">
                  {currentGoals.map((goal, idx) => (
                    <div key={idx} className="space-y-2">
                      <div className="flex justify-between text-sm">
                        <span>{goal.name}</span>
                        <span className="text-muted-foreground">{goal.current}/{goal.target} {goal.unit}</span>
                      </div>
                      <Progress value={(goal.current / goal.target) * 100} className="h-2" />
                    </div>
                  ))}
                  <Button variant="outline" className="w-full" asChild>
                    <Link href="/goals">View All Goals</Link>
                  </Button>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2"><CheckCircle2 className="w-5 h-5 text-accent" /> Recent Activity</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {[
                      { title: "Shadow Boxing", time: "Yesterday", status: "Completed" },
                      { title: "BJJ Drills", time: "2 days ago", status: "Completed" },
                    ].map((item, idx) => (
                      <div key={idx} className="flex justify-between items-center py-2 border-b border-border last:border-0">
                        <div>
                          <p className="font-medium text-sm">{item.title}</p>
                          <p className="text-xs text-muted-foreground">{item.time}</p>
                        </div>
                        <Badge variant="outline" className="text-accent border-accent/30">{item.status}</Badge>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>

          {/* AI Generator CTA */}
          <div className="space-y-6">
            <Card className="bg-primary text-primary-foreground border-none shadow-xl shadow-primary/20">
              <CardHeader>
                <CardTitle className="font-headline text-2xl">TRAIN SMARTER</CardTitle>
                <CardDescription className="text-primary-foreground/80">
                  Generate a custom workout routine tailored to your current equipment and goals.
                </CardDescription>
              </CardHeader>
              <CardContent>
                <Zap className="w-12 h-12 mb-4 opacity-50" />
                <Button variant="secondary" className="w-full" asChild>
                  <Link href="/generator">GENERATE WORKOUT</Link>
                </Button>
              </CardContent>
            </Card>

            <Card className="bg-muted">
              <CardHeader>
                <CardTitle className="text-lg">Pro Tip</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground italic">
                  "The more you sweat in training, the less you bleed in combat. Focus on the basics today."
                </p>
              </CardContent>
            </Card>
          </div>
        </div>
      </main>
    </div>
  );
}

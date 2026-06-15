
"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { Sword, LayoutDashboard, Zap, Trophy, History } from "lucide-react";

export function Navigation() {
  const pathname = usePathname();

  const navItems = [
    { name: "Dashboard", href: "/", icon: LayoutDashboard },
    { name: "AI Generator", href: "/generator", icon: Zap },
    { name: "History", href: "/history", icon: History },
    { name: "Goals", href: "/goals", icon: Trophy },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50 bg-background/80 backdrop-blur-lg border-t border-border md:top-0 md:bottom-auto md:border-t-0 md:border-b h-16">
      <div className="max-w-7xl mx-auto px-4 h-full flex items-center justify-between">
        <Link href="/" className="hidden md:flex items-center gap-2">
          <Sword className="text-primary w-8 h-8" />
          <span className="font-headline font-bold text-xl tracking-widest text-primary">IRON WOLF</span>
        </Link>

        <div className="flex w-full md:w-auto justify-around md:justify-end gap-1 md:gap-8">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={cn(
                  "flex flex-col md:flex-row items-center gap-1 md:gap-2 px-3 py-2 rounded-md text-xs md:text-sm font-medium transition-all duration-200",
                  isActive 
                    ? "text-primary bg-primary/10" 
                    : "text-muted-foreground hover:text-foreground hover:bg-muted"
                )}
              >
                <Icon className={cn("w-5 h-5", isActive && "electric-glow")} />
                <span className="md:inline">{item.name}</span>
              </Link>
            );
          })}
        </div>
      </div>
    </nav>
  );
}
